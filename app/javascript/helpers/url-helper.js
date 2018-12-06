export function changeURLQueryParam(searchParamsString, param, values) {
  const searchParams = new URLSearchParams(searchParamsString);
  searchParams.delete(param);
  if (values instanceof Array) {
    values.forEach(value => searchParams.append(param, value));
  } else if (values) {
    searchParams.append(param, values);
  }
}

export function getURLQueryParams() {
  const searchParams = new URLSearchParams(window.location.search);
  const searchParamsObject = {};

  for (const key of searchParams.keys()) {
    searchParamsObject[key] = searchParams.getAll(key).map((value) => value);
  }

  return searchParamsObject;
}
