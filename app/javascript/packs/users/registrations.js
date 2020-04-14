class Form {
  constructor() {
    this.$el = $('#resource_form');
    this.fields = [
      new EmailField(),
      new PhoneField(),
      new PasswordField(),
      new PasswordConfirmationField(),
    ];

    var self = this;
    $('#resource_submit').on('click', function (e) {
      e.preventDefault();
      e.stopPropagation();

      if (self.validate()) {
        self.$el[0].submit();
        return true;
      } else {
        self.fields.forEach(function (field) {
          if (field.errors.length !== 0) {
            console.warn(field, field.errors);
            field.displayErrors();
          }
        });
        return false;
      }
    });
  }

  validate() {
    console.log('Start form validation');
    var results = [];
    this.fields.forEach(function (field) {
      results.push(field.validate());
    });
    return results.every(r => r);
  }
}

class Field {
  constructor() {
  }

  displayErrors() {
    if (this.errors.length === 0) {
      this.$errors_container.empty().hide();
    } else {
      var $ul = $('<ul>');
      this.errors.forEach(function (error) {
        var $er = $('<li>', {text: error});
        $ul.append($er);
      });
      this.$errors_container.append($ul).show();
    }
  }
}

class EmailField extends Field {
  constructor() {
    super();
    this.$el = $('#resource_email');
    this.$errors_container = $('#resource_email_errors');
    this.errors = [];
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var val = this.$el.val();
    console.log('Start validation', val);

    if (!val || val === '') {
      this.errors.push('メールアドレスを入力してください。');
      return;
    }

    if (!val.match(/^[a-zA-Z0-9\-.]+@[a-zA-Z0-9\-.]+$/)) {
      this.errors.push('有効なメールアドレスを入力してください。');
      return;
    }

    if (val.length > 100) {
      this.errors.push('メールアドレスは100文字以内にしてください。');
    }

    return this.errors.length === 0;
  }
}

class PhoneField extends Field {
  constructor() {
    super();
    this.$el = $('#resource_phone');
    this.$errors_container = $('#resource_phone_errors');
    this.errors = [];
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var val = this.$el.val();
    console.log('Start validation', val);

    val = val.replace(/[０-９]/g, function (s) {
      return String.fromCharCode(s.charCodeAt(0) - 65248);
    });
    val = val.replace(/[-ー]/g, '');
    console.log('Normalized', val);

    if (!val || val === '') {
      this.errors.push('有効な電話番号を入力してください。');
      return;
    }

    if (!val.match(/^0[0-9]{9,10}$/)) {
      this.errors.push('有効な電話番号を入力してください。');
      return;
    }

    return this.errors.length === 0;
  }
}

class PasswordField extends Field {
  constructor() {
    super();
    this.$el = $('#resource_password');
    this.$errors_container = $('#resource_password_errors');
    this.errors = [];
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var val = this.$el.val();
    console.log('Start validation', '***');

    if (!val || val === '' || val.length < 6) {
      this.errors.push('6文字以上のパスワードを入力してください。');
    }

    return this.errors.length === 0;
  }
}

class PasswordConfirmationField extends Field {
  constructor() {
    super();
    this.$el = $('#resource_password_confirmation');
    this.$pw = $('#resource_password');
    this.$errors_container = $('#resource_password_confirmation_errors');
    this.errors = [];
  }

  validate() {
    this.errors = [];
    this.$errors_container.empty().hide();
    var val = this.$el.val();
    console.log('Start validation', '***');

    if (val !== this.$pw.val()) {
      this.errors.push('パスワード（確認用）とパスワードの入力が一致していません。');
    }

    return this.errors.length === 0;
  }
}

$(function () {
  window._form = new Form();
});
