package xyz.yingshaoxo.atlantisspace.user_interface;

import android.content.ComponentName;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import android.os.RemoteException;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import xyz.yingshaoxo.atlantisspace.R;
import xyz.yingshaoxo.atlantisspace.services.ILoadIconCallback;
import xyz.yingshaoxo.atlantisspace.services.IAtlantisSpaceService;
import xyz.yingshaoxo.atlantisspace.utilities.ApplicationInfoWrapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class AppListAdapter extends RecyclerView.Adapter<AppListAdapter.ViewHolder> {
    class ViewHolder extends RecyclerView.ViewHolder {
        private ImageView mIcon;
        private TextView mTitle;
        private TextView mPackage;
        // This text view shows the order of all selected items
        private TextView mSelectOrder;

        private GestureDetector gestureDetector;

        private View current_view;

        int mIndex = -1;

        private class GestureListener extends GestureDetector.SimpleOnGestureListener {
            @Override
            public boolean onSingleTapConfirmed(@NonNull MotionEvent e) {
                onClick();

                return super.onSingleTapConfirmed(e);
            }

            @Override
            public boolean onDoubleTapEvent(@NonNull MotionEvent e) {
                if (mAllowMultiSelect) {
                    // inside
                    if (e.getAction() == MotionEvent.ACTION_UP) {
                        Intent intent = new Intent(DummyActivity.UNFREEZE_AND_LAUNCH);
                        intent.setComponent(new ComponentName(current_view.getContext(), DummyActivity.class));
                        intent.putExtra("packageName", mList.get(mIndex).getPackageName());
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        DummyActivity.registerSameProcessRequest(intent);
                        current_view.getContext().startActivity(intent);
                    }
                } else {
                    // outside
                    onClick();
                }

                return super.onDoubleTapEvent(e);
            }
        }

        ViewHolder(View view) {
            super(view);
            mIcon = view.findViewById(R.id.list_app_icon);
            mTitle = view.findViewById(R.id.list_app_title);
            mPackage = view.findViewById(R.id.list_app_package);
            mSelectOrder = view.findViewById(R.id.list_app_select_order);
            gestureDetector = new GestureDetector(view.getContext(), new GestureListener());

            view.setOnTouchListener((v, motion) -> {
                current_view = v;
                return gestureDetector.onTouchEvent(motion);
            });
        }

        boolean onClick() {
            if (mIndex == -1) return false;

            if (!mMultiSelectMode) {
                // Show available operations via the Fragment
                // pass the full info to it, since we can't be sure
                // the index won't change
                if (mContextMenuHandler != null) {
                    mContextMenuHandler.showContextMenu(mList.get(mIndex), itemView);
                }
            } else {
                // In multi-select mode, single clicks just adds to the selection
                // or cancels the selection if already selected
                if (!mSelectedIndices.contains(mIndex)) {
                    select();
                } else {
                    deselect();
                }
            }

            return false;
        }

        boolean onLongClick() {
            if (mIndex == -1) return false;

            // If we have an action mode handler, we notify it to enter
            // action mode on long click, and register this adapter
            // to be in multi-select mode
            if (!mMultiSelectMode && mActionModeHandler != null && mActionModeHandler.createActionMode()) {
                mMultiSelectMode = true;
                select();
                return true;
            } else {
                return false;
            }
        }

        // When the user selects the item
        // we need to play the animation of the "select order" appearing
        // on the right side of the item view
        void select() {
            mSelectedIndices.add(mIndex);
            mSelectOrder.clearAnimation();
            mSelectOrder.startAnimation(AnimationUtils.loadAnimation(itemView.getContext(), R.anim.scale_appear));
            showSelectOrder();
        }

        // When the user deselects the item
        void deselect() {
            mSelectedIndices.remove((Integer) mIndex);
            mSelectOrder.clearAnimation();
            setUnselectedBackground();
            Animation anim = AnimationUtils.loadAnimation(itemView.getContext(), R.anim.scale_hide);
            anim.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {

                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    if (mActionModeCancelHandler != null && mSelectedIndices.size() == 0) {
                        // If there is no selection left, tell parent to cancel the action mode.
                        mActionModeCancelHandler.cancelActionMode();
                    }
                    // The selection index of items other than this one
                    // can be changed because of the removal of the current one
                    // Thus, we just notify that the data set has been changed,
                    // to force redraw all of them.
                    notifyDataSetChanged();
                }

                @Override
                public void onAnimationRepeat(Animation animation) {

                }
            });
            mSelectOrder.startAnimation(anim);
        }

        // When an item should be displayed in selected state
        // (not necessarily when the user clicked on it; the view might have been recycled)
        void showSelectOrder() {
            if (!mList.get(mIndex).isHidden()) {
                itemView.setBackgroundResource(R.color.selectedAppBackground);
            } else {
                // The app is both frozen and selected
                // we use a blended color of the two for its background
                itemView.setBackgroundResource(R.color.selectedAndDisabledAppBackground);
            }
            mSelectOrder.setVisibility(View.VISIBLE);
            mSelectOrder.setText(String.valueOf(mSelectedIndices.indexOf(mIndex) + 1));
        }

        // When an item should be displayed in deselected state
        void hideSelectOrder() {
            setUnselectedBackground();
            mSelectOrder.setVisibility(View.GONE);
        }

        // Set the background when not in the selected state
        void setUnselectedBackground() {
            if (!mList.get(mIndex).isHidden()) {
                itemView.setBackground(null);
            } else {
                itemView.setBackgroundResource(R.color.disabledAppBackground);
            }
        }

        void setIndex(final int index) {
            mIndex = index;

            if (mIndex >= 0) {
                // Clear all animations first
                mSelectOrder.clearAnimation();

                ApplicationInfoWrapper info = mList.get(mIndex);
                mPackage.setText(info.getPackageName());

                if (info.isHidden()) {
                    String label = String.format(mLabelDisabled, info.getLabel());
                    mTitle.setText(label);
                } else {
                    mTitle.setText(info.getLabel());
                }

                // Special logic when in multi-select mode and this item is selected
                if (mMultiSelectMode && mSelectedIndices.contains(mIndex)) {
                    showSelectOrder();
                } else {
                    hideSelectOrder();
                }

                // Load the application icon from cache
                // or populate the cache through the service
                if (mIconCache.containsKey(info.getPackageName())) {
                    mIcon.setImageBitmap(mIconCache.get(info.getPackageName()));
                } else {
                    mIcon.setImageDrawable(mDefaultIcon);

                    try {
                        mService.loadIcon(info, new ILoadIconCallback.Stub() {
                            @Override
                            public void callback(Bitmap icon) {
                                if (index == mIndex) {
                                    mHandler.post(() -> mIcon.setImageBitmap(icon));
                                }

                                synchronized (AppListAdapter.class) {
                                    mIconCache.put(info.getPackageName(), icon);
                                }
                            }
                        });
                    } catch (RemoteException e) {
                        // Do Nothing
                    }
                }
            }
        }
    }

    interface ContextMenuHandler {
        void showContextMenu(ApplicationInfoWrapper info, View view);
    }

    interface ActionModeHandler {
        boolean createActionMode();
    }

    interface ActionModeCancelHandler {
        void cancelActionMode();
    }

    // The ORIGINAL list of applications without filtering
    private List<ApplicationInfoWrapper> mOrigList = new ArrayList<>();
    // The list of applications that is ACTUALLY displayed
    // (after filtering by search query if applicable)
    private List<ApplicationInfoWrapper> mList = new ArrayList<>();
    private String mSearchQuery = null;
    private IAtlantisSpaceService mService;
    private Drawable mDefaultIcon;
    private String mLabelDisabled;
    private Map<String, Bitmap> mIconCache = new HashMap<>();
    private ContextMenuHandler mContextMenuHandler = null;
    private ActionModeHandler mActionModeHandler = null;
    private ActionModeCancelHandler mActionModeCancelHandler = null;
    private Handler mHandler = new Handler(Looper.getMainLooper());

    // Multi-selection mode
    private boolean mAllowMultiSelect = false;
    private boolean mMultiSelectMode = false;
    private List<Integer> mSelectedIndices = new ArrayList<>();

    AppListAdapter(IAtlantisSpaceService service, Drawable defaultIcon) {
        mService = service;
        mDefaultIcon = defaultIcon;
    }

    void setContextMenuHandler(ContextMenuHandler handler) {
        mContextMenuHandler = handler;
    }

    // When we enter multi-select mode, we have to notify our parent fragment
    // to enter action mode, in order to show the specific menus
    void setActionModeHandler(ActionModeHandler handler) {
        mActionModeHandler = handler;
    }

    // When there is no selection left, we have to notify our parent fragment
    // to exit action mode
    void setActionModeCancelHandler(ActionModeCancelHandler handler) {
        mActionModeCancelHandler = handler;
    }

    void allowMultiSelect() {
        mAllowMultiSelect = true;
    }

    boolean isMultiSelectMode() {
        return mMultiSelectMode;
    }

    void cancelMultiSelectMode() {
        mMultiSelectMode = false;
        mSelectedIndices.clear();
        notifyDataSetChanged();
    }

    List<ApplicationInfoWrapper> getSelectedItems() {
        if (!mMultiSelectMode) return null;
        if (mSelectedIndices.size() == 0) return null;

        return mSelectedIndices.stream()
                .map((idx) -> mList.get(idx))
                .collect(Collectors.toList());
    }

    void setData(List<ApplicationInfoWrapper> apps) {
        mOrigList.clear();
        mList.clear();
        mIconCache.clear();
        mOrigList.addAll(apps);
        notifyChange();
    }

    // null = clear search query
    void setSearchQuery(String query) {
        mSearchQuery = query;
        notifyChange();
    }

    // Call this on ACTUAL data set change and/or search query change
    private void notifyChange() {
        mList.clear();
        if (mSearchQuery == null) {
            // No search query, do not filter
            mList.addAll(mOrigList);
        } else {
            // Filter by search query
            mList.addAll(mOrigList.stream()
                    .filter((app) ->
                            app.getPackageName().toLowerCase().contains(mSearchQuery)
                                    || app.getLabel().toLowerCase().contains(mSearchQuery))
                    .collect(Collectors.toList()));
        }
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        if (mLabelDisabled == null) {
            mLabelDisabled = viewGroup.getContext().getString(R.string.list_item_disabled);
        }
        LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
        View view = inflater.inflate(R.layout.app_list_item, viewGroup, false);
        ViewHolder vh = new ViewHolder(view);
        vh.setIndex(i);
        return vh;
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder viewHolder, int i) {
        viewHolder.setIndex(i);
    }

    @Override
    public void onViewRecycled(@NonNull ViewHolder holder) {
        super.onViewRecycled(holder);
        holder.setIndex(-1);
    }
}
