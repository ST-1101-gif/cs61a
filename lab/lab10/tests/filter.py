test = {
  'name': 'filter',
  'points': 1,
  'suites': [
    {
      'cases': [
        {
          'code': r"""
          scm> (filter even? (list 1 2 3 4 5))
          f6d93158137814c549d98372b81a6666
          # locked
          """,
          'hidden': False,
          'locked': True,
          'multiline': False
        },
        {
          'code': r"""
          scm> (filter (lambda (x) (> x 3)) (list 1 2 3 4 5))
          31c3d2d764cd53b4fdcf8fbf667518c2
          # locked
          """,
          'hidden': False,
          'locked': True,
          'multiline': False
        }
      ],
      'scored': True,
      'setup': r"""
      scm> (load-all ".")
      """,
      'teardown': '',
      'type': 'scheme'
    }
  ]
}
