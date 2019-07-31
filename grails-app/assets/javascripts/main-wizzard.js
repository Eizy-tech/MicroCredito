(function($) {
    var form = $("#signup-form");
    form.validate({
        errorPlacement: function errorPlacement(error, element) {
            // element.before(error);
            element.css({"border": "red dotted 1px"});
        },
        rules: {
            email: {
                email: true
            }
        },
        onfocusout: function(element,value) {
            $(element).valid();
            $(element).css({"border": "1px solid #ccc"});
        },
        onfocusin: function(element,value) {
            $(element).css({"border": "1px solid #40b6e0"});
        }
    });
    form.children("div").steps({
        headerTag: "h3",
        bodyTag: "fieldset",
        transitionEffect: "fade",
        stepsOrientation: "vertical",
        titleTemplate: '<div class="title"><span class="step-number">#index#</span><span class="step-text">#title#</span></div>',
        labels: {
            previous: 'Anterior',
            next: 'Proximo',
            finish: 'Salvar',
            current: ''
        },
        onStepChanging: function(event, currentIndex, newIndex) {
            if(currentIndex < newIndex ){       //validar so quando faz next
                form.validate().settings.ignore = ":disabled,:hidden";
                return form.valid();
            }else{                              //nao valida
                return true
            }
        },
        onFinishing: function(event, currentIndex) {
            form.validate().settings.ignore = ":disabled";
            return form.valid();
        },
        onFinished: function(event, currentIndex) {
            // alert('Submited');
            $(this).submit();
        },
        onStepChanged: function(event, currentIndex, priorIndex) {
            return true;
        }
    });

    jQuery.extend(jQuery.validator.messages, {
        required: "",
        remote: "",
        email: "",
        url: "",
        date: "",
        dateISO: "",
        number: "",
        digits: "",
        creditcard: "",
        equalTo: ""
    });

    var marginSlider = document.getElementById('slider-margin');
    if (marginSlider != undefined) {
        noUiSlider.create(marginSlider, {
              start: [1100],
              step: 100,
              connect: [true, false],
              tooltips: [true],
              range: {
                  'min': 100,
                  'max': 2000
              },
              pips: {
                    mode: 'values',
                    values: [100, 2000],
                    density: 4
                    },
                format: wNumb({
                    decimals: 0,
                    thousand: '',
                    prefix: '$ ',
                })
        });
        var marginMin = document.getElementById('value-lower'),
	    marginMax = document.getElementById('value-upper');

        marginSlider.noUiSlider.on('update', function ( values, handle ) {
            if ( handle ) {
                marginMax.innerHTML = values[handle];
            } else {
                marginMin.innerHTML = values[handle];
            }
        });
    }
})(jQuery);