export default function () {
  return {
    namespaced: true,

    state: {
      loading: false,
      path: '',
      hasChanged: false,
      pageParams: {
        page: 1,
        pages: 1,
        limit: 50,
        total: 1,
        order: 'updated_at',
        filter_string: null,
        direction: 'desc'
      }
    },

    getters: {},

    actions: {},

    mutations: {
      /**
       * @param state
       * @param payload
       */
      setLoading(state, payload) {
        state.loading = payload;
      },

      /**
       * @param state
       * @param payload
       */
      setPath(state, payload) {
        state.path = payload;
      },

      /**
       * @param state
       * @param payload
       */
      toggleHasChanged(state, payload) {
        state.hasChanged = payload;
      },

      /**
       * @param state
       * @param payload
       */
      setPage(state, payload) {
        state.pageParams.page = parseInt(payload, 10);
      },

      /**
       * @param state
       * @param payload
       */
      setTotal(state, payload) {
        state.pageParams.total = payload;
      },

      /**
       * @param state
       * @param payload
       */
      setLimit(state, payload) {
        state.pageParams.limit = payload;
      },

      /**
       * @param state
       * @param payload
       */
      setFilterString(state, payload) {
        state.pageParams.filter_string = payload;
      },

      /**
       * @param state
       * @param payload
       */
      setOrder(state, payload) {
        state.pageParams.order = payload;
      },

      /**
       * @param state
       * @param payload
       */
      setDirection(state, payload) {
        state.pageParams.direction = payload;
      }
    }
  };
}
