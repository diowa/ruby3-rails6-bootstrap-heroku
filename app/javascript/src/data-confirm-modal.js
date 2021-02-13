/*
 * Implements a user-facing modal confirmation when link has a
 * "data-confirm" attribute using bootstrap's modals. MIT license.
 *
 *   - vjt@openssl.it  Tue Jul  2 18:45:15 CEST 2013
 */
($ => {
  /**
   * Builds the markup for a [Bootstrap modal](http://twitter.github.io/bootstrap/javascript.html#modals)
   * for the given `element`. Uses the following `data-` parameters to
   * customize it:
   *
   *  * `data-confirm`: Contains the modal body text. HTML is allowed.
   *                    Separate multiple paragraphs using \n\n.
   *  * `data-commit`:  The 'confirm' button text. "Confirm" by default.
   *  * `data-cancel`:  The 'cancel' button text. "Cancel" by default.
   *  * `data-verify`:  Adds a text input in which the user has to input
   *                    the text in this attribute value for the 'confirm'
   *                    button to be clickable. Optional.
   *  * `data-verify-text`:  Adds a label for the data-verify input. Optional
   *  * `data-focus`:   Define focused input. Supported values are
   *                    'cancel' or 'commit', 'cancel' is default for
   *                    data-method DELETE, 'commit' for all others.
   *
   * You can set global setting using `dataConfirmModal.setDefaults`, for example:
   *
   *    dataConfirmModal.setDefaults({
   *      title: 'Confirm your action',
   *      commit: 'Continue',
   *      cancel: 'Cancel',
   *      fade:   false,
   *      verifyClass: 'form-control',
   *    });
   *
   */

  const defaults = {
    title: 'Are you sure?',
    commit: 'Confirm',
    commitClass: 'btn-danger',
    cancel: 'Cancel',
    cancelClass: 'btn-default',
    fade: true,
    verifyClass: 'form-control',
    elements: ['a[data-confirm]', 'button[data-confirm]', 'input[type=submit][data-confirm]'],
    focus: 'commit',
    zIndex: 1050,
    modalClass: false,
    modalCloseContent: '&times;',
    show: true
  }

  let settings

  window.dataConfirmModal = {
    setDefaults (newSettings) {
      settings = $.extend(settings, newSettings)
    },

    restoreDefaults () {
      settings = $.extend({}, defaults)
    },

    confirm (options) {
      // Build an ephemeral modal
      //
      const modal = buildModal(options)

      modal.spawn()
      modal.on('hidden.bs.modal', () => {
        modal.remove()
      })

      modal.find('.commit').on('click', () => {
        if (options.onConfirm && options.onConfirm.call) { options.onConfirm.call() }

        modal.modal('hide')
      })

      modal.find('.cancel').on('click', () => {
        if (options.onCancel && options.onCancel.call) { options.onCancel.call() }

        modal.modal('hide')
      })

      modal.on('hidden.bs.modal', () => {
        if (options.onHide && options.onHide.call) { options.onHide.call() }
      })
    }
  }

  dataConfirmModal.restoreDefaults()

  // Detect bootstrap version, or bail out.
  //
  if ($.fn.modal == undefined) {
    throw new Error('The bootstrap modal plugin does not appear to be loaded.')
  }

  if ($.fn.modal.Constructor == undefined) {
    throw new Error('The bootstrap modal plugin does not have a Constructor ?!?')
  }

  if ($.fn.modal.Constructor.VERSION == undefined) {
    throw new Error('The bootstrap modal plugin does not have its version defined ?!?')
  }

  const versionString = $.fn.modal.Constructor.VERSION
  const match = versionString.match(/^(\d)\./)
  if (!match) {
    throw new Error(`Cannot identify Bootstrap version. Version string: ${versionString}`)
  }

  const bootstrapVersion = parseInt(match[1])
  if (bootstrapVersion != 3 && bootstrapVersion != 4) {
    throw new Error(`Unsupported bootstrap version: ${bootstrapVersion}. data-confirm-modal supports version 3 and 4.`)
  }

  const buildElementModal = element => {
    const options = {
      title: element.data('title') || element.attr('title') || element.data('original-title'),
      text: element.data('confirm'),
      focus: element.data('focus'),
      method: element.data('method'),
      modalClass: element.data('modal-class'),
      modalCloseContent: element.data('modal-close-content'),
      commit: element.data('commit'),
      commitClass: element.data('commit-class'),
      cancel: element.data('cancel'),
      cancelClass: element.data('cancel-class'),
      remote: element.data('remote'),
      verify: element.data('verify'),
      verifyRegexp: element.data('verify-regexp'),
      verifyLabel: element.data('verify-text'),
      verifyRegexpCaseInsensitive: element.data('verify-regexp-caseinsensitive'),
      backdrop: element.data('backdrop'),
      keyboard: element.data('keyboard'),
      show: element.data('show')
    }

    const modal = buildModal(options)

    modal.find('.commit').on('click', () => {
      // Call the original event handler chain
      element.get(0).click()

      modal.modal('hide')
    })

    return modal
  }

  var buildModal = options => {
    const id = `confirm-modal-${String(Math.random()).slice(2, -1)}`
    const fade = settings.fade ? 'fade' : ''
    const modalClass = options.modalClass ? options.modalClass : settings.modalClass

    const modalCloseContent = options.modalCloseContent ? options.modalCloseContent : settings.modalCloseContent
    const modalClose = `<button type="button" class="close" data-dismiss="modal" aria-hidden="true">${modalCloseContent}</button>`

    const modalTitle = `<h5 id="${id}Label" class="modal-title"></h5> `
    let modalHeader

    // Bootstrap 3 and 4 have different DOMs and different CSS. In B4, the
    // modalHeader is display:flex and the modalClose uses negative margins,
    // so it can stay after the modalTitle.
    //
    // In B3, the close button floats to the right, so it must stay before
    // the modalTitle.
    //
    switch (bootstrapVersion) {
      case 3:
        modalHeader = modalClose + modalTitle
        break
      case 4:
        modalHeader = modalTitle + modalClose
        break
    }

    const modal = $(
      `<div id="${id}" class="modal ${modalClass} ${fade}" tabindex="-1" role="dialog" aria-labelledby="${id}Label" aria-hidden="true"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header">${modalHeader}</div><div class="modal-body"></div><div class="modal-footer"><button class="btn cancel" data-dismiss="modal" aria-hidden="true"></button><button class="btn commit"></button></div></div></div></div>`
    )

    // Make sure it's always the top zindex
    let highest

    let current
    highest = current = settings.zIndex
    $('.modal.in').not(`#${id}`).each(function () {
      current = parseInt($(this).css('z-index'), 10)
      if (current > highest) {
        highest = current
      }
    })
    modal.css('z-index', parseInt(highest) + 1)

    modal.find('.modal-title').text(options.title || settings.title)

    const body = modal.find('.modal-body')

    $.each((options.text || '').split(/\n{2}/), (i, piece) => {
      body.append($('<p/>').html(piece))
    })

    const commit = modal.find('.commit')
    commit.text(options.commit || settings.commit)
    commit.addClass(options.commitClass || settings.commitClass)

    const cancel = modal.find('.cancel')
    cancel.text(options.cancel || settings.cancel)
    cancel.addClass(options.cancelClass || settings.cancelClass)

    if (options.remote) {
      commit.attr('data-dismiss', 'modal')
    }

    if (options.verify || options.verifyRegexp) {
      commit.prop('disabled', true)

      let isMatch
      if (options.verifyRegexp) {
        const caseInsensitive = options.verifyRegexpCaseInsensitive
        const regexp = options.verifyRegexp
        const re = new RegExp(regexp, caseInsensitive ? 'i' : '')

        isMatch = input => input.match(re)
      } else {
        isMatch = input => options.verify == input
      }

      const verification = $('<input/>', { type: 'text', class: settings.verifyClass }).on('keyup', function () {
        commit.prop('disabled', !isMatch($(this).val()))
      })

      modal.on('shown.bs.modal', () => {
        verification.focus()
      })

      modal.on('hidden.bs.modal', () => {
        verification.val('').trigger('keyup')
      })

      if (options.verifyLabel) { body.append($('<p>', { text: options.verifyLabel })) }

      body.append(verification)
    }

    let focus_element
    if (options.focus) {
      focus_element = options.focus
    } else if (options.method == 'delete') {
      focus_element = 'cancel'
    } else {
      focus_element = settings.focus
    }
    focus_element = modal.find(`.${focus_element}`)

    modal.on('shown.bs.modal', () => {
      focus_element.focus()
    })

    $('body').append(modal)

    modal.spawn = () => modal.modal($.extend({}, {
      backdrop: options.backdrop,
      keyboard: options.keyboard,
      show: options.show
    }))

    return modal
  }

  /**
   * Returns a modal already built for the given element or builds a new one,
   * caching it into the element's `confirm-modal` data attribute.
   */
  $.fn.getConfirmModal = function () {
    const element = $(this)
    let modal = element.data('confirm-modal')

    if (!modal) {
      modal = buildElementModal(element)
      element.data('confirm-modal', modal)
    }

    return modal
  }

  $.fn.confirmModal = function () {
    const modal = $(this).getConfirmModal()

    modal.spawn()

    return modal
  }

  if (window.Rails || $.rails) {
    /**
     * Attaches to Rails' UJS adapter's 'confirm' event, triggered on elements
     * having a `data-confirm` attribute set.
     *
     * If the modal is not visible, then it is spawned and the default Rails
     * confirmation dialog is canceled.
     *
     * If the modal is visible, it means the handler is being called by the
     * modal commit button click handler, as such the user has successfully
     * clicked on the confirm button. In this case Rails' confirm function
     * is briefly overriden, and afterwards reset when the modal is closed.
     *
     */
    const window_confirm = window.confirm

    $(document).delegate(settings.elements.join(', '), 'confirm', function () {
      const modal = $(this).getConfirmModal()

      if (!modal.is(':visible')) {
        modal.spawn()

        // Cancel Rails' confirmation
        return false
      } else {
        // Modal has been confirmed. Override Rails' handler
        window.confirm = () => true

        modal.one('hidden.bs.modal', () => {
          // Reset it after modal is closed.
          window.confirm = window_confirm
        })

        // Proceed with Rails' handlers
        return true
      }
    })
  }
})(jQuery)
