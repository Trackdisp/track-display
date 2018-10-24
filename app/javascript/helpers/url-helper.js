export default function changeURLQueryParam(param, values) {
  const searchParams = new URLSearchParams(window.location.search);
  searchParams.delete(param);
  if (values instanceof Array) {
    values.forEach(value => searchParams.append(param, value));
  } else if (values) {
    searchParams.append(param, values);
  }

  return searchParams.toString();
}
