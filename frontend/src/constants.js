export const REQUEST_STATE = {
    // APIリクエスト中に画面がいまどういう状態なのか？を知るための状態
    INITIAL: 'INITIAL',
    // APIリクエスト中としてローディング
    LOADING: 'LOADING',
    // 成功したアラート
    OK: 'OK',
  }
  
  export const HTTP_STATUS_CODE = {
    NOT_ACCEPTABLE: 406,
  }