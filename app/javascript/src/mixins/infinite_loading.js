/**
 * 無限ローディング共通処理
 */

export default {
  data() {
    return {};
  },

  methods: {
    /**
     * リストにホバーした時のイベント
     */
    mouseoverList() {
      const scrollTop = this.$refs.tableScroll.scrollTop;
      const offsetHeight = this.$refs.tableScroll.offsetHeight;
      const scrollHeight = this.$refs.tableScroll.scrollHeight;

      if (scrollTop === 0 && offsetHeight === scrollHeight) {
        this.loadInPhases();
      }
    },

    /**
     * リストをスクロールした時のイベント
     */
    scrollList() {
      const scrollTop = this.$refs.tableScroll.scrollTop;
      const offsetHeight = this.$refs.tableScroll.offsetHeight;
      const scrollHeight = this.$refs.tableScroll.scrollHeight;

      if (scrollTop + offsetHeight >= scrollHeight) {
        this.loadInPhases();
      }
    }
  }
};
