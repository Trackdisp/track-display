export default function changeURLQueryParam(url, param, value) {
  const parser = document.createElement('a');
  parser.href = url;
  const searchParams = new URLSearchParams(parser.search);
  searchParams.set(param, value);
  parser.search = searchParams.toString();

  return parser.href;
}
