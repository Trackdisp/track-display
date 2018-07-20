export function changeURLQueryParam(param, value) {
  const searchParams = new URLSearchParams(window.location.search);
  searchParams.set(param, value);

  return searchParams.toString();
}

export function removeURLQueryParam(param) {
  const searchParams = new URLSearchParams(window.location.search);
  searchParams.delete(param);

  return searchParams.toString();
}
