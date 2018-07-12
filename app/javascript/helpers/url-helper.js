export function changeURLQueryParam(url, param, value) {
  const parser = document.createElement('a');
  parser.href = url;
  const searchParams = new URLSearchParams(parser.search);
  searchParams.set(param, value);
  parser.search = searchParams.toString();

  return parser.href;
}

export function removeURLQueryParam(url, param) {
  const parser = document.createElement('a');
  parser.href = url;
  const searchParams = new URLSearchParams(parser.search);
  searchParams.delete(param);
  parser.search = searchParams.toString();

  return parser.href;
}
