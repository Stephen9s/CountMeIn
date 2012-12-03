atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated

  @events.each do |event|
    next if event.updated_at.blank?

    feed.entry( event ) do |post|
      post.url event_path(post)
      post.title event.name
      post.content "Location: " + event.location, :type => 'html'

    end
  end
end