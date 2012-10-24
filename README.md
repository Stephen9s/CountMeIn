To retrieve the current user's ID, use

    current_user.id   << Must use this, not just current_user to get the ID

To find a user's friendships, use

    @friends = current_user.all_friends + current_user.all_inverse_friends

To find a user's memberships, use

    @joined_events = current_user.all_memberships