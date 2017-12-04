class Admin::ModerationHistoryController < Admin::AdminController

  def index
    history_filter = params[:filter]
    raise Discourse::NotFound unless ['post', 'topic'].include?(history_filter)

    posts = []
    case history_filter
    when 'post'
      raise Discourse::NotFound if params[:post_id].blank?
      posts = [Post.where(id: params[:post_id]).first]
    when 'topic'
      raise Discourse::NotFound if params[:topic_id].blank?
      posts = [Post.where(topic_id: params[:topic_id])]
    end
    posts.compact!

    render_serialized(
      UserHistory.where(
        post_id: posts.map(&:id),
        action: UserHistory.actions.only(
          :delete_user,
          :suspend_user,
          :silence_user,
          :delete_post,
          :delete_topic
        ).values
      ),
      UserHistorySerializer,
      root: 'moderation_history',
      rest_serializer: true
    )
  end

end
