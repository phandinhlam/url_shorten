class Home {
  
  constructor() {
    this.bindEvent();
  }

  submitForm(form, callback) {
    let data = new FormData(form);
    $.ajax({
      url: form.action,
      type: form.method,
      cache: false,
      contentType: false,
      processData: false,
      data: data,
      success: (res) => { callback(res); },
      error: (e) => {
      }
    });
  };

  encode(e) {
    e.preventDefault();
    let form = $(e)[0].currentTarget;
    this.submitForm(form, (res) => {
      if (res.code == 200) {
        $('#encode-result').text(res.data.url);
      }
    });
  };

  decode(e) {
    e.preventDefault();
    let form = $(e)[0].currentTarget;
    this.submitForm(form, (res) => {
      if (res.code == 200) {
        $('#decode-result').text(res.data.url);
      }
    });
  };

  bindEvent() {
    $('.encode-form')[0].addEventListener('submit', e => { this.encode(e); });
    $('.decode-form')[0].addEventListener('submit', e => { this.decode(e); });
  };
}

jQuery(() => {
  new Home();
})
