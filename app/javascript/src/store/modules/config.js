export default {
  namespaced: true,

  state: {
    env: null,
    operator: {},
    shortEnv: null,
    service: null,
    locale: null,
    firebaseToken: null,
    firebaseAuth: false,
    timeZone: null,
    csrfParam: null,
    csrfToken: null,
    flatpickrDefaultOptions: null
  },

  getters: {
    isFsUser: state => state.operator.category_type === 2
  },

  mutations: {
    /**
     * @param state
     * @param config
     */
    init(state, config) {
      Object.keys(state).forEach(k => {
        state[k] = k === 'operator' ? JSON.parse(config[k]) : config[k];
      });
    },

    /**
     * @param state
     * @param payload
     */
    setFirebaseAuth(state, payload) {
      state.firebaseAuth = payload;
    }
  }
};
