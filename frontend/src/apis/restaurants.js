import axios from 'axios';
import { restaurantsIndex } from '../urls/index'

export const fetchRestaurants =() => {
  return axios.get(restaurantsIndex)
// 成功した場合
// 返り値をresという名前で取得し、res.dataでレスポンスの中身だけをreturnしています
  .then(res => {
    return res.data
  })
// 失敗した場合
// エラーメッセージをコンソールに出す
// 本来的にはバリデーションエラーメッセージを返す
  .catch((e) => console.error(e))
}
