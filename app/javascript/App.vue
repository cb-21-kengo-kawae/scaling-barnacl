<template lang="pug">
  #base_container.w-100.h-100(@click.stop="backdrop")
    router-view
    FAppHeader(:user="operator")
    app-validation-error-modal
</template>

<script>
import { mapState, mapMutations } from 'vuex';
import AppValidationErrorModal from './src/components/AppValidationErrorModal';

export default {
  components: { AppValidationErrorModal },

  provide: function () {
    const config = {};
    Object.defineProperty(config, 'key', {
      enumerable: true,
      get: () => this.$parent.config
    });
    return { config };
  },

  data() {
    return {};
  },

  computed: {
    ...mapState('config', ['operator'])
  },

  created() {
    this.initConfig(this.$parent.config);
    this.setPolicies(this.operator.policies);
  },

  mounted() {},

  methods: {
    ...mapMutations('config', { initConfig: 'init' }),
    ...mapMutations('policy', ['setPolicies']),

    backdrop() {
      // eslint-disable-next-line vue/custom-event-name-casing
      this.$root.$emit('bv::hide::popover', 'appNotificationBtn');
    }
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
