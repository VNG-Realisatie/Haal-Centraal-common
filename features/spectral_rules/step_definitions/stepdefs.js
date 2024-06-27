const { Given, When, Then } = require('@cucumber/cucumber');
const { Spectral, Document } = require('@stoplight/spectral-core');
const Parsers = require('@stoplight/spectral-parsers');
const { bundleAndLoadRuleset } = require('@stoplight/spectral-ruleset-bundler/with-loader');
const { fetch } = require('@stoplight/spectral-runtime');
const { join } = require('path');
const should = require('chai').should();
const fs = require('node:fs');

Given('de spectral rule {string}', function (rule) {
    this.rule = rule;
});

Given('de OpenAPI specificatie', function (oasSpecificatie) {
    this.oasSpecificatie = new Document(oasSpecificatie, Parsers.Yaml);
});

When('de OpenAPI specificatie is gevalideerd met spectral', async function () {
    const spectral = new Spectral();
    const filePath = join(__dirname, '../../../spectral_rules/' + this.rule + '.yml');
    const ruleset = await bundleAndLoadRuleset(filePath, { fs, fetch });
    spectral.setRuleset(ruleset);
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
