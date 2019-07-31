<div class="vertical-alignment-helper">
    <div class="modal-dialog vertical-align-center">
        <div class="modal-content" style="border-radius: 5px; width: 40%">
            <div class="modal-body m-0 p-0" id="cliente-corpo">
                <div class="box box-default">
                    <div class="box-header with-border">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="box-title"><i class="fa fa-list"></i> Garantias</h4>
                    </div>
                    <div class="box-body pr-4 pl-4">
                        <div class="row pt-3">
                            <g:each in="${garantias}" var="garantia" status="i">
                                <div class="col-sm-12">
                                    <div class="box box-warning">
                                        <div class="box-header with-border">
                                            <h3 class="box-title"><b>${i+1}ª Garantia</b></h3>
                                        </div>
                                        <div class="box-body">
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <div class="list-group mb-1">
                                                        <a class="list-group-item">
                                                            Tipo de garantia: <b class="pull-right">${garantia.tipoGarantia.descricao} </b>
                                                        </a>
                                                    </div>

                                                    <textarea  readonly class="mb-2 form-control" rows="3" wrap="soft">
                                                        ${garantia.descricao}
                                                    </textarea>

                                                    <div class="list-group mb-1">
                                                        <a class="list-group-item">
                                                            Localização: <b class="pull-right">${garantia.localizacao} </b>
                                                        </a>
                                                        <a class="list-group-item">
                                                            Valor: <b class="pull-right">${garantia.valor} </b>
                                                        </a>
                                                        <a class="list-group-item">
                                                            Latitude: <b class="pull-right">${garantia.latitude}</b>
                                                        </a>
                                                        <a class="list-group-item">
                                                            Longitude: <b class="pull-right">${garantia.longitude}</b>
                                                        </a>
                                                    </div>
                                                </div>

                                                <div class="col-sm-6">
                                                    <div class="box-body box-profile mt-0" style="background-color: white">
                                                        <h5 class="text-center"><b>Foto/Fotografia</b></h5>
                                                        <img src="<g:createLink controller="garantia" action="showImage" id="${garantia.id}"/>"
                                                             class="profile-user-img img-responsive img-rounded" style="height: 245px; width: 100%"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </g:each>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-danger pull-right" data-dismiss="modal" id="btn-cancel-cliente">Fechar</button>
            </div>
        </div>
    </div>
</div>