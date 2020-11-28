<template lang="pug">
  b-modal(
    v-model="enabled"
    id="appValidationErrorModal"
    @hide="disable"
    modal-class="modal-error"
    dialog-class="modal-dialog-centered"
  )
    template(slot="modal-header")
      .modal-title
        | {{ 'common.modals.error.title.error' | t }}
    b-container.modal-body-content
      .description-msg
        | {{ 'common.modals.error.message' | t }}
      ul.list-box-gray
        li(v-for="msg in errorMessages")
          pre
            | •&nbsp;{{ msg }}
    template(slot="modal-footer")
      button.btn.btn-error(@click="disable")
        | {{ 'common.button.confirm' | t }}
</template>

<script>
import { mapState, mapMutations } from 'vuex';

export default {
  name: 'AppValidationErrorModal',

  computed: {
    ...mapState('appValidationErrors', ['errorMessages', 'showErrorModal']),

    enabled: {
      get() {
        return this.errorMessages.length > 0 && this.showErrorModal;
      },
      set() {}
    }
  },

  methods: {
    ...mapMutations('appValidationErrors', ['clearErrors']),

    disable() {
      this.clearErrors();
    }
  }
};
</script>

<style scoped lang="scss">
pre {
  overflow: unset;
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style>
