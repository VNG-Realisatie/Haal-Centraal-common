const { Given, When, Then } = require('@cucumber/cucumber');
const { Spectral, Document, Parsers, isOpenApiv3 } = require('@stoplight/spectral');
const { join } = require('path');
const should = require('chai').should();

Given('de spectral rule {string}', function (rule) {
    this.rule = rule;
});

Given('de OpenAPI specificatie', function (oasSpecificatie) {
    this.oasSpecificatie = new Document(oasSpecificatie, Parsers.Yaml);
});

When('de OpenAPI specificatie is gevalideerd met spectral', async function () {
    const spectral = new Spectral();
    spectral.registerFormat('oas3', isOpenApiv3);
    await spectral.loadRuleset([
        join(__dirname, '../../../spectral_rules/test-rule.yml'),
        join(__dirname, '../../../spectral_rules/' + this.rule + '.yml')
    ]);
    this.results = await spectral.run(this.oasSpecificatie);
});

Then('bevat spectral\'s resultaat geen validatie meldingen', function () {
    this.results.should.have.lengthOf(0, JSON.stringify(this.results, null, "\t"));
});

Then('bevat spectral\'s resultaat de validatie melding {string}', function (expected) {
    this.results.should.have.lengthOf(1, JSON.stringify(this.results, null, "\t"));
    this.results[0].code.should.equal(this.rule, JSON.stringify(this.results, null, "\t"));
    this.results[0].message.should.equal(expected, JSON.stringify(this.results, null, "\t"));
});
