module.exports = (...ids) => {
  return `
    SELECT DISTINCT ?item ?label WHERE {
      VALUES ?item { ${ids.map(value => `wd:${value}`).join(' ')} }
      { ?item rdfs:label ?label } UNION { ?item skos:altLabel ?label }
    }
    # ${new Date().toISOString()}
    ORDER BY ?item ?label`
}
