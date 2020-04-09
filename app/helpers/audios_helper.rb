module AudiosHelper
  def duration_text(duration)
    if duration.nil? || duration < 0
    elsif duration <= 60
      t('datetime.distance_in_words.x_seconds.other', count: duration)
    elsif duration < 3600
      t('datetime.distance_in_words.x_minutes.other', count: duration / 60)
    end
  end
end
