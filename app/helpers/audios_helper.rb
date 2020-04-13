module AudiosHelper
  def duration_text(duration)
    if duration.nil? || duration < 0
    elsif duration <= 60
      t('datetime.distance_in_words.x_seconds', count: duration)
    elsif duration < 3600
      t('datetime.distance_in_words.x_minutes', count: duration / 60)
    else
      if duration % 3600 == 0
        t('datetime.distance_in_words.about_x_hours', count: duration / 3600)
      else
        t('datetime.distance_in_words.about_x_hours', count: duration / 3600) + duration_text(duration % 3600)
      end
    end
  end

  def remaining_duration_text(requests, fake:)
    if fake
      duration = FreeTrial.total_duration
    else
      duration = FreeTrial.total_duration - requests.map(&:audio).compact.map(&:duration).sum
    end
    duration_text(duration)
  end

  def expiration_kinds(key_suffix = nil)
    keys = %i(guest login paid)
    keys = keys.map { |k| "#{k}_#{key_suffix}".to_sym } if key_suffix

    {
        keys[0] => t('layouts.application.expiration_for.guest'),
        keys[1] => t('layouts.application.expiration_for.login'),
        keys[2] => t('layouts.application.expiration_for.paid')
    }
  end

  def files_count_kinds(key_suffix = nil)
    keys = %i(guest login paid)
    keys = keys.map { |k| "#{k}_#{key_suffix}".to_sym } if key_suffix

    {
        keys[0] => t('layouts.application.files_count_for.guest'),
        keys[1] => t('layouts.application.files_count_for.login'),
        keys[2] => t('layouts.application.files_count_for.paid')
    }
  end
end
