/* ================================================================
   VOYASTRA FORM VALIDATION LIBRARY — validate.js
   Declarative, zero-dependency, toast-integrated validator.

   Usage: add data-validate attributes to inputs, then call:
       VoyastraValidate.bind('formId');
   or auto-bind all forms with:
       VoyastraValidate.bindAll();

   Supported data attributes on <input>/<textarea>/<select>:
     data-v-required          → "Field is required"
     data-v-email             → email format check
     data-v-min-len="N"       → minimum character length
     data-v-max-len="N"       → maximum character length
     data-v-min="N"           → numeric minimum value
     data-v-max="N"           → numeric maximum value
     data-v-number            → must be a valid positive number
     data-v-match="#otherId"  → must match another field's value
     data-v-label="Field"     → friendly name in error messages
   ================================================================ */

(function(window) {
    'use strict';

    var EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    var NUM_RE   = /^\d+(\.\d+)?$/;

    /* ── Inline error helper ─────────────────────────────────── */
    function getErrEl(field) {
        var id = field.id + '_verr';
        var el = document.getElementById(id);
        if (!el) {
            el = document.createElement('span');
            el.id = id;
            el.className = 'vx-field-error';
            el.setAttribute('role', 'alert');
            field.parentNode.insertBefore(el, field.nextSibling);
        }
        return el;
    }

    function showErr(field, msg) {
        field.classList.add('vx-invalid');
        field.classList.remove('vx-valid');
        var el = getErrEl(field);
        el.textContent = msg;
        el.style.display = 'block';
    }

    function clearErr(field) {
        field.classList.remove('vx-invalid');
        field.classList.add('vx-valid');
        var el = document.getElementById(field.id + '_verr');
        if (el) { el.textContent = ''; el.style.display = 'none'; }
    }

    /* ── Validate a single field ─────────────────────────────── */
    function validateField(field) {
        var val   = field.value.trim();
        var label = field.getAttribute('data-v-label') || field.name || 'This field';
        var ds    = field.dataset;

        // Required
        if (ds.vRequired !== undefined && val === '') {
            showErr(field, label + ' is required.');
            return false;
        }
        if (val === '') { clearErr(field); return true; } // optional empty field

        // Email
        if (ds.vEmail !== undefined && !EMAIL_RE.test(val)) {
            showErr(field, 'Please enter a valid email address.');
            return false;
        }

        // Number (must be numeric positive value)
        if (ds.vNumber !== undefined) {
            if (!NUM_RE.test(val) || parseFloat(val) < 0) {
                showErr(field, label + ' must be a valid positive number.');
                return false;
            }
        }

        // Min value
        if (ds.vMin !== undefined) {
            var minV = parseFloat(ds.vMin);
            if (isNaN(parseFloat(val)) || parseFloat(val) < minV) {
                showErr(field, label + ' must be at least ' + minV + '.');
                return false;
            }
        }

        // Max value
        if (ds.vMax !== undefined) {
            var maxV = parseFloat(ds.vMax);
            if (!isNaN(parseFloat(val)) && parseFloat(val) > maxV) {
                showErr(field, label + ' cannot exceed ' + maxV + '.');
                return false;
            }
        }

        // Min length
        if (ds.vMinLen !== undefined && val.length < parseInt(ds.vMinLen, 10)) {
            showErr(field, label + ' must be at least ' + ds.vMinLen + ' characters.');
            return false;
        }

        // Max length
        if (ds.vMaxLen !== undefined && val.length > parseInt(ds.vMaxLen, 10)) {
            showErr(field, label + ' cannot exceed ' + ds.vMaxLen + ' characters.');
            return false;
        }

        // Match
        if (ds.vMatch) {
            var other = document.querySelector(ds.vMatch);
            if (other && val !== other.value.trim()) {
                showErr(field, label + ' does not match.');
                return false;
            }
        }

        clearErr(field);
        return true;
    }

    /* ── Bind a single form ──────────────────────────────────── */
    function bind(formId) {
        var form = typeof formId === 'string' ? document.getElementById(formId) : formId;
        if (!form) return;

        var fields = form.querySelectorAll('[data-v-required],[data-v-email],[data-v-number],[data-v-min],[data-v-max],[data-v-min-len],[data-v-max-len],[data-v-match]');

        // Live inline feedback on blur
        fields.forEach(function(f) {
            f.addEventListener('blur', function() { validateField(f); });
            f.addEventListener('input', function() {
                if (f.classList.contains('vx-invalid')) validateField(f);
            });
        });

        // Submit guard
        form.addEventListener('submit', function(e) {
            var allValid = true;
            var firstInvalid = null;

            fields.forEach(function(f) {
                if (!validateField(f)) {
                    allValid = false;
                    if (!firstInvalid) firstInvalid = f;
                }
            });

            if (!allValid) {
                e.preventDefault();
                e.stopPropagation();
                if (firstInvalid) firstInvalid.focus();
                if (window.VoyastraToast) {
                    VoyastraToast.show('Please fix the errors below before submitting.', 'warning');
                }
            }
        });
    }

    /* ── Auto-bind all forms that have data-vx attribute ─────── */
    function bindAll() {
        document.querySelectorAll('form[data-vx]').forEach(function(form) {
            bind(form);
        });
    }

    /* ── Init on DOMContentLoaded ────────────────────────────── */
    document.addEventListener('DOMContentLoaded', bindAll);

    window.VoyastraValidate = { bind: bind, bindAll: bindAll, validateField: validateField };

})(window);
