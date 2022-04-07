// Define some style properties to apply on hosted-fields inputs 
var style = {
    "input": {
        "font-size": "1em",
    },
    "::placeholder": {
        "font-size": "1em",
        "color": "#777",
        "font-style": "italic"
    }
};
var hfields
// Initialize the hosted-fields library
JavascriptChannelInit.postMessage("initializing payment");

// Manage the token creation
function tokenizeHandler() {
    hfields.createToken(function (result) {
        //console.log(result);
        if (result.execCode == '0000') {
            var full_name = $('#full_name').val();
            JavascriptChannel.postMessage(
                result.cardCode + ","
                + result.cardValidityDate + ","
                + result.cardType + ","
                + result.selectedBrand + ","
                + full_name + ","
                + result.hfToken);
        }
    });
    return false;
}

function setValue(elem) {
    DALENYS_APIKEY = elem;
}

function setkeyId(elem) {
    DALENYS_APIKEY_ID = elem;
    hfields = dalenys.hostedFields({
        // API Keys
        key: {
            id: DALENYS_APIKEY_ID,
            value: DALENYS_APIKEY
        },
        // Manages each hosted-field container
        fields: {
            'brand': {
                id: 'brand-container'
            },
            'card': {
                id: 'card-container',
                placeholder: '•••• •••• •••• ••••',
                enableAutospacing: true,
                style: style
            },
            'expiry': {
                id: 'expiry-container',
                placeholder: 'MM/YY',
                style: style
            },
            'cryptogram': {
                id: 'cvv-container',
                style: style
            }
        }
    });
}



$(document).ready(function () {
    $("#payment-form").validate(
        {
            rules: {
                full_name: "required",
                acceptCGV: "required"
            },
            messages: {
                full_name: "Vous devez entrez le nom du porteur de carte",
                acceptCGV: "Vous devez accepter les conditions générales de vente"
            },
            submitHandler: function (form) {
                return tokenizeHandler();
            }
        }
    );
    hfields.load();
});

function openCGV() {
    JavascriptChannelOpenCGV.postMessage("Open CGV");
}