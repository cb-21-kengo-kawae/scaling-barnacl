<template lang="pug">
  input(
    type="number"
    ref="input"
    :min="min"
    :max="max"
    v-model="current"
    @blur="$emit('blur')"
  )
</template>

<script>
export default {
  props: {
    value: {
      type: [String, Number],
      default: NaN
    },

    min: {
      type: Number,
      default: 0
    },

    max: {
      type: Number,
      default: 100
    }
  },

  data() {
    return {};
  },

  computed: {
    current: {
      get() {
        return this.value;
      },

      set(val) {
        const value = Math.min(this.max, Math.max(this.min, val));

        this.$refs.input.value = value;
        this.$emit('input', value);
      }
    }
  }
};
</script>

<style scoped lang="scss"></style>
