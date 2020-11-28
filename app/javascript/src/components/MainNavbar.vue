<template lang="pug">
  .l-header
    .header-global
      .global-nav
        a.header-logo
          img(:src="brandLogo" alt="b→dash Marketing Cloud")

</template>

<script>
import brandLogo from 'fs-designpack/src/assets/images/common/bdash_logo.svg';
export default {
  data: function () {
    return {};
  },
  computed: {},
  created() {},
  beforeCreate() {
    this.brandLogo = brandLogo;
  },
  mounted() {},
  methods: {}
};
</script>

<style scoped lang="scss"></style>
