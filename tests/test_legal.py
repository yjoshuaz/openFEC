from tests.common import ApiBaseTest

from webservices.rest import api
from webservices.resources.legal import AdvisoryOpinion, Search

class TestLegal(ApiBaseTest):

    def test_advisory_opinion(self):
        results = self._results(api.url_for(AdvisoryOpinion, ao_no='2014-72'))
        self.assertTrue('docs' in results)

    def test_legal_search(self):
        results = self._results(api.url_for(Search, q='computers', type='all'))
        self.assertTrue('regulations' in results)
        self.assertTrue('advisory_opinions' in results)
