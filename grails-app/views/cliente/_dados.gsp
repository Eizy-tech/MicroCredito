%{--<% def inscricao1Service = grailsApplication.classLoader.loadClass('escola.Inscricao1Service').newInstance() %>--}%
<div class="vertical-alignment-helper">
    <div class="modal-dialog vertical-align-center">
        <div class="modal-content" style="border-radius: 5px; width: 70%">
            <div class="modal-body m-0 p-0" id="cliente-corpo">
                <div class="box box-default">
                    <div class="box-header with-border">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <h4 class="box-title"><i class="fa fa-user"></i> Dados do cliente</h4>
                    </div>
                    <div class="box-body pr-4 pl-4">
                        <div class="row pt-3">
                            <div class="col-md-4">
                                <div class="box box-primary">
                                    <div class="box-body box-profile" style="background-color: white">
                                        <img src="<g:createLink controller="cliente" action="showImage"/>" class="profile-user-img img-responsive img-circle" id="foto-cliente" style="height: 100px;"/>
                                        <p class="profile-username text-center">${cliente.nome}</p>
                                        <ul class="list-group list-group-unbordered mb-3 pr-4 pl-4">
                                            <li class="list-group-item">
                                                <b>Codigo:</b> <a class="pull-right">${cliente.codigo}</a>
                                            </li>
                                            <li class="list-group-item">
                                                <b>Numero de Emprestimos:</b> <a class="pull-right ">${cliente.emprestimos.size()}</a>
                                            </li>
                                            <li class="list-group-item">
                                                <b>Total Valor Pago:</b> <a class="pull-right">######</a>
                                            </li>
                                            %{--<li class="list-group-item">--}%
                                                %{--<b>Total Valor Divida:</b> <a class="pull-right text-bold text-red" id="inscricao_divida">34</a>--}%
                                            %{--</li>--}%
                                        </ul>
                                        %{--<g:link target="_blank" class="btn btn-sm btn-default mb-2 ml-2"  style="color: black; width: 95%; font-size: 15px"--}%
                                                %{--controller="inscricao" action="verFicha" id="${inscricao.id}">--}%
                                            %{--<i class="fa fa-file-pdf" style="color: red"></i>&nbsp;Ficha do cliente--}%
                                        %{--</g:link>--}%
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4">
                                <div class="list-group">
                                    <a class="list-group-item">
                                        Estado: <b class="pull-right">${cliente.estado} </b>
                                    </a>
                                    <a class="list-group-item">
                                        Estado Civil: <b class="pull-right">${cliente.estadoCivil} </b>
                                    </a>
                                    <g:if test="${cliente.estadoCivil.equalsIgnoreCase('Casado')}">
                                        <a class="list-group-item">
                                            Nome do Cônjuge: <b class="pull-right">${cliente.nomeConjuge} </b>
                                        </a>
                                    </g:if>
                                    <a class="list-group-item">
                                        Naturalidade: <b class="pull-right">${cliente.naturalidade} </b>
                                    </a>
                                    <a class="list-group-item">
                                        Nacionalidade: <b class="pull-right">${cliente.nacionalidade} </b>
                                    </a>
                                    %{--<a class="list-group-item">--}%
                                        %{--Tipo de Contrato: <b class="pull-right">${cliente.tipoContrato} </b>--}%
                                    %{--</a>--}%
                                    %{--<a class="list-group-item">--}%
                                        %{--Ano de Admissão: <b class="pull-right">${cliente.anoAdmissao} </b>--}%
                                    %{--</a>--}%
                                    <a class="list-group-item">
                                        Contacto: <b class="pull-right">${cliente.contacto1} </b>
                                    </a>
                                    <a class="list-group-item">
                                        Contacto Opcional: <b class="pull-right">${cliente.contacto2} </b>
                                    </a>
                                    <a class="list-group-item">
                                        Email: <b class="pull-right">${cliente.email}</b>
                                    </a>
                                </div>
                            </div>

                            <div class="col-lg-4">
                                <div class="list-group">
                                    <a class="list-group-item">
                                        Tipo | Nº do Documento: <b class="pull-right">${cliente.tipoDocumento.descricao} | ${cliente.nrDocumento}</b>
                                    </a>
                                    <a class="list-group-item">
                                        Data de Emissão: <b class="pull-right"><g:formatDate date="${cliente.dataEmissao}" format="dd MMM yyyy"/> </b>
                                    </a>
                                    <a class="list-group-item">
                                        Local de Emissão: <b class="pull-right">${cliente.localEmissao} </b>
                                    </a>
                                    <a class="list-group-item">
                                        Data de Validade: <b class="pull-right"><g:formatDate date="${cliente.dataValidade}" format="dd MMM yyyy"/> </b>
                                    </a>
                                    <a class="list-group-item">
                                        Provincia | Distrito: <b class="pull-right">${cliente.distrito.provincia.designacao} | ${cliente.distrito.designacao} </b>
                                    </a>
                                    <a class="list-group-item" style="height: 80px">
                                        Endereço: <b class="pull-right">${cliente.endereco}</b>
                                    </a>
                                </div>
                            </div>
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