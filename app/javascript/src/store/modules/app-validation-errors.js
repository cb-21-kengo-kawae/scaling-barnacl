export default {
  namespaced: true,

  state: {
    errorMessages: [],
    showErrorModal: false
  },

  mutations: {
    /**
     * @param {Object} state
     * @param {Object} params パラメタ
     */
    setErrors(state, params) {
      state.errorMessages = params.messages;
      state.showErrorModal = params.showModal;
    },

    /**
     * エラーをクリアする。
     * @param {Object} state
     */
    clearErrors(state) {
      state.errorMessages = [];
      state.showErrorModal = false;
    }
  }
};
