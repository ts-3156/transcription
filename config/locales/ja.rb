{
    ja: {
        layouts: {
            application: {
                files_count_for: {
                    guest: "#{Guest.files_count_limit}個",
                    login: "#{User.files_count_limit(false)}個",
                    paid: '無制限'
                },
                expiration_for: {
                    guest: "#{Guest.expiration_limit / 1.hour}時間",
                    login: "#{User.expiration_limit(false) / 1.day}日間",
                    paid: "#{User.expiration_limit(true) / 1.year}年間"
                },
                free_duration: "#{FreeTrial.total_duration / 1.hour}時間",
                each_duration: "#{FreeTrial.each_duration / 1.minute}分"
            }
        }
    }
}
