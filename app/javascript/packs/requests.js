class Form {
  constructor() {
    this.$el = $('#model_form');
    this.name = new NameField();
    this.audio = new FileField();
    this.$submit = $('#model_form_submit');

    var self = this;
    this.$submit.on('click', function (e) {
      e.preventDefault();
      e.stopPropagation();

      if (self.validate()) {
        self.$el[0].submit();
        return true;
      } else {
        if (self.name.errors.length !== 0) {
          console.warn('name', self.name.errors);
          self.name.displayErrors();
        }
        if (self.audio.errors.length !== 0) {
          console.warn('audio', self.audio.errors);
          self.audio.displayErrors();
        }
        return false;
      }
    });
  }

  validate() {
    console.log('Start form validation', this.$name, this.$audio);
    var r1 = this.name.validate();
    var r2 = this.audio.validate();
    return r1 && r2;
  }
}

class NameField {
  constructor() {
    this.$el = $('#model_form_name');
    this.$errors_container = $('#model_form_name_errors');
    this.errors = [];
  }

  val() {
    return this.$el.val();
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var val = this.val();
    console.log('Start name validation', val);

    if (Util.countChars(val) > 50) {
      this.errors.push('名前メモは50文字以内にしてください。');
    }

    return this.errors.length === 0;
  }

  displayErrors() {
    if (this.errors.length === 0) {
      this.$errors_container.empty().hide();
    } else {
      var message = this.errors.join('<br>');
      this.$errors_container.html(message).show();
    }
  }
}

class FileField {
  constructor() {
    this.$el = $('#model_form_audio');
    this.$errors_container = $('#model_form_audio_errors');
    this.errors = [];

    var self = this;
    this.$el.on('change', function () {
      var files = self.files();
      if (files.length !== 1) {
        console.warn('files.length is not 1.', files.length);
        return;
      }

      $(this).next('.custom-file-label').text(files[0].name).removeClass('text-muted');
    });
  }

  files() {
    return this.$el[0].files;
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var files = this.files();
    console.log('Start audio valiadtion', files);

    if (files.length !== 1) {
      this.errors.push('音声または動画ファイルを選択してください。WAV、FLAC、MP3、MP4形式に対応しています。');
      return;
    }

    var file = files[0];

    if (file.type.match(/video/i)) {
      this.errors.push('動画ファイルは有料プランのみ利用できます。');
    }

    if (!file.type.match(/audio/i)) {
      this.errors.push('音声または動画ファイルを選択してください。WAV、FLAC、MP3、MP4形式に対応しています。');
    }

    if (file.size > 120000000) { // 120 MB
      this.errors.push('120 MBより大きいファイルは有料プランのみ利用できます。');
    }

    return this.errors.length === 0;
  }

  displayErrors() {
    if (this.errors.length === 0) {
      this.$errors_container.empty().hide();
    } else {
      var message = this.errors.join('<br>');
      this.$errors_container.html(message).show();
    }
  }
}

class Util {
  constructor() {
  }

  static countChars(str) {
    var len = 0;
    str = str.split("");

    for (var i = 0; i < str.length; i++) {
      if (str[i].match(/[ｦ-ﾟ]+/)) {
        len++;
      } else {
        if (escape(str[i]).match(/^\%u/)) {
          len += 2;
        } else {
          len++;
        }
      }
    }

    return len;
  }
}

$(function () {
  var form = new Form();
});
