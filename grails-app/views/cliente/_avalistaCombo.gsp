<label class="form-label" for="avalista">Avalista</label>
<div class="input-group">
    <div class="has-feedback has-clear">
        <g:select id="avalista" name="avalista" optionKey="id"  optionValue="nome" data-size="10"
                      from="${cliente.list()}" class="form-control select2" style="width: 100%"
                      noSelection="${['null':'Seleciona avalista']}"/>
    </div>
    <div class="input-group-btn">
        <button type="button" class="btn btn-default text-red" id="btn-clean-alavista" title="Limpar Campo">X</button>
        <button type="button" class="btn btn-default" id="btn-add-avalista" title="Adicionar Avalista">Add</button>
    </div>
</div>