import Gateway from './api_gateway';

import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/database';

export default class Firebase {
  /**
   * params {string}
   */
  constructor(path) {
    this.firebasePath = path;
    this.firebaseRef = null;
    this.firebaseListeners = {
      child_added: null,
      child_changed: null,
      child_removed: null
    };
  }

  /**
   * @return {void}
   */
  push() {}

  /**
   * データのアップデート
   * @param {Object} data
   * @return {void}
   */
  update(data) {
    if (this.firebaseRef) {
      this.firebaseRef.update(data);
    }
  }

  /**
   * @return {void}
   */
  unbind() {
    const listeners = this.firebaseListeners;

    if (this.firebaseRef) {
      Object.keys(listeners).forEach(key => {
        this.firebaseRef.off(key, listeners[key]);
      });
    }

    this.firebaseRef = null;
    this.firebaseListeners = Object.create(null);
  }

  /**
   * 初回読み込み処理、追加処理
   *
   * @param {function} func
   */
  onAdded(func) {
    const onAdd = this.firebaseRef.on('child_added', (snapshot, prevKey) => func(snapshot, prevKey));
    this.firebaseListeners.child_added = onAdd;
  }

  /**
   * 変更処理
   *
   * @param {function} func
   */
  onChanged(func) {
    const onChange = this.firebaseRef.on('child_changed', snapshot => func(snapshot));
    this.firebaseListeners.child_changed = onChange;
  }

  /**
   * 削除処理
   *
   * @param {function} func
   */
  onRemoved(func) {
    const onRemove = this.firebaseRef.on('child_removed', snapshot => func(snapshot));
    this.firebaseListeners.child_removed = onRemove;
  }

  /**
   * @return {void}
   */
  setRef() {
    if (!this.firebasePath) return;

    this.firebaseRef = firebase.database().ref(this.firebasePath);
  }

  /**
   * @return promise object
   */
  authorize() {
    // TODO: 通知機能復活時に再検討する
    // if (firebase.apps.length) return;

    const gateway = new Gateway('firebase');

    return gateway
      .get({ action: 'token' })
      .then(response => {
        // 同一のAPIkeyでfirebase appが登録されている場合はなにもしない
        const duplicate_app = firebase.apps.find(app => app.options.apiKey === response.body.api_key);
        if (duplicate_app) {
          return;
        }
        firebase.initializeApp({
          apiKey: response.body.api_key,
          authDomain: response.body.auth_domain,
          databaseURL: response.body.database_url
        });

        var user = firebase.auth().currentUser;
        if (user) {
          // ログイン済み
          // https://firebase.google.com/docs/auth/web/manage-users
        } else {
          firebase
            .auth()
            .signInWithCustomToken(response.body.token)
            .catch(error => {
              if (error.code === 'auth/invalid-custom-token') {
                throw new Error('The token you provided is not valid.');
              }
              throw new Error(error);
            });
        }
      })
      .catch(error => {
        throw new Error(error);
      });
  }
}
