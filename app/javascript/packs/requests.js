class Form {
  constructor() {
    this.$el = $('#model_form');
    this.name = new NameField();
    this.audio = new FileField();

    var self = this;
    $('#model_form_submit').on('click', function (e) {
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
    this.$filename_container = null;
    this.$errors_container = $('#model_form_audio_errors');
    this.errors = [];
    this.duration = null;

    var self = this;
    this.$el.on('change', function () {
      self.$filename_container = $('#audio_filename');
      self.$filename_container.empty().hide();
      self.$errors_container.empty().hide();

      var files = self.files();
      console.log('File selected', files);

      if (files.length === 1) {
        $('#audio_browse_file').hide();
        self.$filename_container.text('ファイルサイズのチェック中です。').show();
        self.duration = null;

        Util.getDuration((files[0])).then(function (result) {
          self.duration = result;
          self.$filename_container.text(files[0].name).show();
          if (!self.validate()) {
            self.displayErrors();
          }
        });
      } else {
        $('#audio_browse_file').show();
      }
    });
  }

  files() {
    return this.$el[0].files;
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var files = this.files();
    console.log('Start audio valiadtion', files, 'duration', this.duration);

    if (files.length !== 1) {
      this.errors.push('音声または動画ファイルを選択してください。WAV、FLAC、MP3、MP4形式に対応しています。');
      return;
    }

    if (!this.duration) {
      this.errors.push('ファイルサイズのチェック中です。1〜10秒ほどお待ちください。');
      return;
    }

    var file = files[0];

    if (file.type.match(/video/i)) {
      this.errors.push('動画ファイルは有料プランのみ利用できます。');
    }

    if (!file.type.match(/audio/i)) {
      this.errors.push('音声または動画ファイルを選択してください。WAV、FLAC、MP3、MP4形式に対応しています。');
    }

    if (file.size > 120_000_000) { // 120 MB
      this.errors.push('120MB より大きいファイルは有料プランのみ利用できます。');
    }

    if (this.duration > 3600) { // 1 hour
      this.errors.push('1時間 より長いファイルは有料プランのみ利用できます。');
    }

    return this.errors.length === 0;
  }

  displayErrors() {
    if (this.errors.length === 0) {
      this.$errors_container.empty().hide();
    } else {
      var message = this.errors.join('<br>');
      this.$errors_container.html(message).show();
      this.shake(this.$errors_container);
    }
  }

  shake($elem) {
    $elem.addClass('shake');
    setTimeout(function () {
      $elem.removeClass('shake');
    }, 500);
  }

  duration(file) {

  }
}

class Util {
  constructor() {
  }

  static countChars(str) {
    if (!str) {
      return -1;
    }

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

  static getDuration(file) {
    return new Promise(function (resolve) {
      if (file.type.match(/audio/)) {
        var audio = document.createElement('audio');
        var reader = new FileReader();

        reader.onload = function (e) {
          audio.src = e.target.result;
          audio.addEventListener('loadedmetadata', function () {
            console.log('duration', parseInt(audio.duration));
            resolve(audio.duration);
          }, false);
        };

        reader.readAsDataURL(file);
      } else {
        console.log('duration', null);
        resolve();
      }
    });
  }
}

$(function () {
  window._form = new Form();
});
