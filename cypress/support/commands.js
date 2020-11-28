// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

Cypress.Commands.add('login', (options = {}) => {
  const testUser = Cypress.env('testUser');

  const host = options.host || Cypress.env('homeUrl');
  const identifier = options.identifier || testUser.identifier;
  const email = options.email || testUser.email;
  const password = options.password || testUser.password;

  cy.clearCookies();

  cy.visit(host);

  cy.url().should('include', '/auth/users/sign_in');

  cy.get('#user_accounts_attributes_0_identifier')
    .clear()
    .type(identifier);

  cy.get('#user_email').type(email);

  cy.get('#user_password').type(password);

  cy.get('[name="commit"]').click();
});

/** FIX ME */
Cypress.Commands.add('logout', () => {
  cy.get('.header-user-btn button.dropdown-toggle').click();
  cy.get('.header-user-btn a.dropdown-item')
    .contains('ログアウト')
    .closest('a')
    .click();
});

/**
 * IT環境用 ログアウト
 */
Cypress.Commands.add('iTLogout', () => {
  cy.get('.header-user-btn button.dropdown-toggle').click();
  cy.wait(400).then(() => {
    cy.get('.header-user-btn a.dropdown-item')
      .contains('ログアウト')
      .closest('a')
      .click();
  });
});
