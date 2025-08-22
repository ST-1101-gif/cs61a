test = {
  'name': 'last',
  'points': 1,
  'suites': [
    {
      'cases': [
        {
          'code': r"""
          scm> (last (list 1))
          1
          scm> (last (list (list 1 2) (list 3 4) (list 5 6)))
          (5 6)
          scm> (last (list 1 2 3 4 5))
          5
          scm> (define (make-list n)
          ....    (define (helper i sofar)
          ....      (if (= i 0)
          ....          sofar
          ....          (helper (- i 1) (cons i sofar))))
          ....    (helper n nil))
          make-list
          scm> (last (make-list 50000)) ; Test for tail recursion
          50000
          """,
          'hidden': False,
          'locked': False,
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
