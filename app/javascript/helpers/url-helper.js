export function changeURLQueryParam(searchParamsString, param, values) {
  const searchParams = new URLSearchParams(searchParamsString);
  searchParams.delete(param);
  if (values instanceof Array) {
    values.forEach(value => searchParams.append(param, value));
  } else if (values) {
    searchParams.append(param, values);
  }

  return searchParams.toString();
}

export function getURLQueryParams() {
  const searchParams = new URLSearchParams(window.location.search);

  return searchParams.toString();
}
