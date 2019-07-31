package microcredito

class ContaBancaria {
	String numero, banco, nib, titular, estado, referencia, observacao

    static constraints = {
        numero(nullable: false)
        banco(nullable: false)
        observacao(maxSize: 255)
        estado(inList: ['Activo', 'Inactivo'])
    }
}
