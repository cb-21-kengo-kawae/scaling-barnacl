describe('ログイン', () => {
  beforeEach(() => {
    cy.server();
    cy.login();
  });

  afterEach(() => {
    cy.logout();
  });

  describe('ヘッダの表示', () => {
    it('ヘッダが表示されていること', () => {
      cy.get('.header-logo [alt="b→dash Marketing Cloud"]')
        .should('be.visible')
        .and(($img) => {
          expect($img[0].naturalWidth).to.be.greaterThan(0)
        });
    });
  });
});
