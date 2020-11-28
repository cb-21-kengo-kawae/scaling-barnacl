<template lang="pug">
.template-page
  f-app-header-control
    .left-block
      a.btn.i-arrow_back(
        href="/platform/home"
      )
  f-background-dot
  .l-main.visible(style="display: block")
    .content
      .content-header
        .page-description
          | {{ '実施する操作を選択しましょう' }}
      .content-main
</template>

<script>
import { defineComponent } from '@vue/composition-api';

export default defineComponent({
  name: 'Index',

  created() {},
  mounted() {}
});
</script>

<style lang="scss" scoped></style>
