const SurveyFactory = artifacts.require('SurveyFactory');
const {Utils} = artifacts.require("EmbarkJS");

let accounts;

config({
  //blockchain: {
  //  accounts: [
  //    // you can configure custom accounts with a custom balance
  //    // see https://framework.embarklabs.io/docs/contracts_testing.html#Configuring-accounts
  //  ]
  //},
  contracts: {
    deploy: {
      "SurveyFactory": {
        args: [1000000000000]
      }
    }
  }
}, (_err, web3_accounts) => {
  accounts = web3_accounts;
});


contract("SurveyFactory", function () {
  this.timeout(0);

  // Test#1
  it("1. Given that i'm the survey owner, when i try to create a survey and include the survey creation costs then i should be able to get the created survey reference number and ", async function () {

    let result = await SurveyFactory.methods
      .createSurvey()
      .send({from: accounts[1], value: 1200000000000 });

    let sur_id = result.events.SurveyCreated.returnValues["surveyId"];
    let sur_addr = result.events.SurveyCreated.returnValues["surveyAddress"];

    // the first survey should be starting with id 1
    assert.equal(parseInt(sur_id, 10), 1);

    // the address
    assert.equal(web3.utils.isAddress(sur_addr), true)

  });

  it("2. Given that i'm the survey owner, when i try to create ", async function () {

    const survey_owner = accounts[1];
    const result = await SurveyFactory.methods.createSurvey().send({from:survey_owner, value:1200000000000});

    let sur_id = result.events.SurveyCreated.returnValues["surveyId"];
    let sur_addr = await SurveyFactory.methods.surveyToOwner(sur_id).call();

    assert.equal(survey_owner, sur_addr);

  });

  // Test#3
  it("3. If i'm the survery owner, when i try to create a survey and include the survey without survey creation cost, then i should receive a revert error", async function () {
    const survey_owner = accounts[1];
    assert.reverts(
      await SurveyFactory.methods.createSurvey(), {from: survey_owner}, "Returned error: VM Exception while processing transaction: revert Value must be greater then"
    );
  });

  // Test#4
  it("4. If i'm survey Marketplace's app owner, when i try to create a new survey then i should receive a revert error", async function () {

    const survey_dapp_owner = await SurveyFactory.methods.owner().call();
    assert.reverts(
      await SurveyFactory.methods.createSurvey(), {from: survey_dapp_owner, value: 1200000000000 },
      "Returned Error: VM Exception while processing transaction: revert Owner"
    );

  });

})
