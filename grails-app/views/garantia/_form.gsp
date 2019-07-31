<div class="col-sm-6 box-garantia" id="box-garantia-${params.index}">
    <div class="box box-warning">
        <div class="box-header with-border">
            <h3 class="box-title"><strong id="box-title-nr-${params.index}">${params.index}ª</strong> Garantia</h3>
            <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool btn-add-garantia" title="Adicionar Outra Garantia"><i class="fa fa-plus"></i></button>
                %{--<button type="button" class="btn btn-box-tool btn-remove-garantia" data-id="${params.index}" id="btn-remove-${params.index}"  title="Remover"><i class="fa fa-times"></i></button>--}%
            </div>
        </div>
        <div class="box-body">
            <div class="row">
                <div class="col-sm-6 pr-1">
                    <g:select id="tipoGarantia" name="tipoGarantia${params.index}" optionKey="descricao"  optionValue="descricao" title="Tipo de garantia"
                              from="${tipoGarantiaList}" class="form-control mb-2 select tipoGarantia" required="true"/>
                    <textarea placeholder="Descricao" name="descricao${params.index}" class="mb-2 form-control select textarea" rows="3" required></textarea>
                    <input placeholder="valor" name="valor${params.index}" type="text" class="form-control mb-2 input-valor-garantia" required value="0">
                </div>
                <div class="col-sm-6 pl-1">
                    <input placeholder="Localização" name="localizacao${params.index}" type="text" class="form-control mb-2" required>
                    <input placeholder="Latitude" name="latitude${params.index}" type="text" class="form-control mb-2 latitude-longitude" value="0" required>
                    <input placeholder="Longitude" name="longitude${params.index}" type="text" class="form-control mb-1 latitude-longitude" value="0" required>
                    <label for="file-${params.index}" id="label-file-${params.index}" class="btn btn-sm btn-primary form-control" title="Carregar Foto">Foto</label>
                </div>
            </div>
            <input type="file" id="file-${params.index}" name="foto${params.index}" accept="image/*" class="hidden input-upload">
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('.tipoGarantia').editableSelect();

        $.fn.inputFilterGarantia = function(inputFilter) {
            return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function() {
                if (inputFilter(this.value)) {
                    this.oldValue = this.value;
                    this.oldSelectionStart = this.selectionStart;
                    this.oldSelectionEnd = this.selectionEnd;
                } else if (this.hasOwnProperty("oldValue")) {
                    this.value = this.oldValue;
                    this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
                }
            });
        };
        $(".input-valor-garantia").inputFilterGarantia(function(value) {
            // return /^\d*$/.test(value) && (value === "" || value.length <= 20);
        });
        $('.textarea').on('focusin', function () {
            $('#'+$(this).attr('name')+'-error').remove();
        });

        $(".latitude-longitude").inputFilterGarantia(function(value) {
            // return /^\d*$/.test(value) && (value === "" || value.length <= 50);
        });
    });
</script>