module AudiosHelper
  def duration_text(duration)
    if duration.nil? || duration < 0
    elsif duration <= 60
      t('datetime.distance_in_words.x_seconds.other', count: duration)
    elsif duration < 3600
      t('datetime.distance_in_words.x_minutes.other', count: duration / 60)
    else
      if duration % 3600 == 0
        t('datetime.distance_in_words.about_x_hours.other', count: duration / 3600)
      else
        t('datetime.distance_in_words.about_x_hours.other', count: duration / 3600) + duration_text(duration % 3600)
      end
    end
  end

  def remaining_duration_text(requests)
    duration = t('layouts.application.free_duration_seconds') - requests.map(&:audio).compact.map(&:duration).sum
    duration_text(duration)
  end

  def expiration_kinds
    @expiration_kinds ||= {
        guest: t('layouts.application.expiration_for.guest'),
        login: t('layouts.application.expiration_for.login'),
        paid: t('layouts.application.expiration_for.paid')
    }
  end
end
