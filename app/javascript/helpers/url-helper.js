export function changeURLQueryParam(param, value) {
  const searchParams = new URLSearchParams(window.location.search);
  searchParams.set(param, value);

  return searchParams.toString();
}

export function getURLFilterParams() {
  const searchParams = new URLSearchParams(window.location.search);
  const searchParamsObject = {};

  for (const key of searchParams.keys()) {
    if (key !== 'group_by') {
      searchParamsObject[key] = searchParams.getAll(key).map((value) => value);
    }
  }

  return searchParamsObject;
}

export function getURLQueryParam(param) {
  const searchParams = new URLSearchParams(window.location.search);

  return searchParams.get(param);
}
