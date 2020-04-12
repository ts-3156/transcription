const changeInput = `
<div class="jFiler-input-dragDrop">
  <div class="jFiler-input-inner">
    <div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div>
    <div id="audio_filename" class="mb-3" style="display: none;"></div>
    <div id="audio_browse_file" class="jFiler-input-text">
      <h3>ファイルをドロップ</h3> <span style="display:inline-block; margin: 15px 0">または</span>
		</div>
    <a class="jFiler-input-choose-btn blue">ファイルを選択する</a>
	</div>
</div>
`;

$(document).ready(function () {

  $("#model_form_audio").filer({
    limit: 1,
    maxSize: 120,
    fileMaxSize: 120,
    extensions: null,
    changeInput: changeInput,
    showThumbs: false,
    theme: "dragdropbox",
    templates: {
      box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
      item: '<li class="jFiler-item">\
						<div class="jFiler-item-container">\
							<div class="jFiler-item-inner">\
								<div class="jFiler-item-thumb">\
									<div class="jFiler-item-status"></div>\
									<div class="jFiler-item-thumb-overlay">\
										<div class="jFiler-item-info">\
											<div style="display:table-cell;vertical-align: middle;">\
												<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name}}</b></span>\
												<span class="jFiler-item-others">{{fi-size2}}</span>\
											</div>\
										</div>\
									</div>\
									{{fi-image}}\
								</div>\
								<div class="jFiler-item-assets jFiler-row">\
									<ul class="list-inline pull-left">\
										<li>{{fi-progressBar}}</li>\
									</ul>\
									<ul class="list-inline pull-right">\
										<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
									</ul>\
								</div>\
							</div>\
						</div>\
					</li>',
      itemAppend: '<li class="jFiler-item">\
							<div class="jFiler-item-container">\
								<div class="jFiler-item-inner">\
									<div class="jFiler-item-thumb">\
										<div class="jFiler-item-status"></div>\
										<div class="jFiler-item-thumb-overlay">\
											<div class="jFiler-item-info">\
												<div style="display:table-cell;vertical-align: middle;">\
													<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name}}</b></span>\
													<span class="jFiler-item-others">{{fi-size2}}</span>\
												</div>\
											</div>\
										</div>\
										{{fi-image}}\
									</div>\
									<div class="jFiler-item-assets jFiler-row">\
										<ul class="list-inline pull-left">\
											<li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
										</ul>\
										<ul class="list-inline pull-right">\
											<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
										</ul>\
									</div>\
								</div>\
							</div>\
						</li>',
      progressBar: '<div class="bar"></div>',
      itemAppendToEnd: false,
      canvasImage: true,
      removeConfirmation: true,
      _selectors: {
        list: '.jFiler-items-list',
        item: '.jFiler-item',
        progressBar: '.bar',
        remove: '.jFiler-item-trash-action'
      }
    },
    dragDrop: {
      dragEnter: null,
      dragLeave: null,
      drop: function (files) {
        $('#model_form_audio')[0].files = files;
        $('#model_form_audio').trigger('change');
      },
      dragContainer: null,
    },
    files: null,
    addMore: false,
    allowDuplicates: true,
    clipBoardPaste: true,
    excludeName: null,
    beforeRender: null,
    afterRender: null,
    beforeShow: null,
    beforeSelect: null,
    onSelect: null,
    afterShow: null,
    onEmpty: null,
    options: null,
    dialogs: {
      alert: function (text) {
        return alert(text);
      },
      confirm: function (text, callback) {
        confirm(text) ? callback() : null;
      }
    },
    captions: {
      button: "Choose Files",
      feedback: "Choose files To Upload",
      feedback2: "files were chosen",
      drop: "Drop file here to Upload",
      removeConfirmation: "Are you sure you want to remove this file?",
      errors: {
        filesLimit: "Only {{fi-limit}} files are allowed to be uploaded.",
        filesType: "Only Images are allowed to be uploaded.",
        filesSize: "{{fi-name}} is too large! Please upload file up to {{fi-maxSize}} MB.",
        filesSizeAll: "Files you've choosed are too large! Please upload files up to {{fi-maxSize}} MB."
      }
    }
  });
})
