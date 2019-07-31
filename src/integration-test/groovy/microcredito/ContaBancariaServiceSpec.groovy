package microcredito

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class ContaBancariaServiceSpec extends Specification {

    ContaBancariaService contaBancariaService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new ContaBancaria(...).save(flush: true, failOnError: true)
        //new ContaBancaria(...).save(flush: true, failOnError: true)
        //ContaBancaria contaBancaria = new ContaBancaria(...).save(flush: true, failOnError: true)
        //new ContaBancaria(...).save(flush: true, failOnError: true)
        //new ContaBancaria(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //contaBancaria.id
    }

    void "test get"() {
        setupData()

        expect:
        contaBancariaService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<ContaBancaria> contaBancariaList = contaBancariaService.list(max: 2, offset: 2)

        then:
        contaBancariaList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        contaBancariaService.count() == 5
    }

    void "test delete"() {
        Long contaBancariaId = setupData()

        expect:
        contaBancariaService.count() == 5

        when:
        contaBancariaService.delete(contaBancariaId)
        sessionFactory.currentSession.flush()

        then:
        contaBancariaService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        ContaBancaria contaBancaria = new ContaBancaria()
        contaBancariaService.save(contaBancaria)

        then:
        contaBancaria.id != null
    }
}
