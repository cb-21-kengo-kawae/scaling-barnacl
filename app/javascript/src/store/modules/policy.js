const POLICY_LEVELS = { unused: 0, nothing: 1, read_only: 2, edit: 3 };

export default {
  namespaced: true,

  state: {
    policies: {}
  },

  getters: {
    can(state) {
      /**
       * 操作権限があるかを判定
       * NOTE: fs-zeldaplugin Policify::InstanceMethods#can? と挙動をあわせています。
       */
      return (level, policyIdentifier) => {
        const ability = state.policies[policyIdentifier] || 'nothing';
        return POLICY_LEVELS[ability] >= POLICY_LEVELS[level];
      };
    },

    cannot(_, getters) {
      return (...args) => {
        debugger;
        return !getters.can(...args);
      };
    }
  },

  actions: {},

  mutations: {
    setPolicies(state, policies) {
      state.policies = policies;
    }
  }
};
