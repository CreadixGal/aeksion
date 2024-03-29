import { Controller } from "@hotwired/stimulus"
import flatpickr  from "flatpickr"

export default class extends Controller {
  static targets = [ "calendar", "search" ]
  
  connect() {
    if (this.hasCalendarTarget) this.calendar()
    if (this.hasSearchTarget) this.search()
  }

  calendar() {
    let calendar = this.calendarTarget
    calendar.config = {
      enableTime: false,
      dateFormat: "d-m-Y",
      maxDate: new Date().fp_incr(3),
      allowInput: true,
      disable: [
        function(date) {
            return (date.getDay() === 0);
        }
      ],
      locale: {
        "firstDayOfWeek": 1 // start week on Monday
      },
      locale: Spanish
    }

    return flatpickr(calendar, calendar.config)
  }

  search() {
    let search = this.searchTarget
    let formElement = search.closest('form'); // Obtener el formulario relacionado


    search.config = {
      enableTime: false,
      dateFormat: "d-m-Y",
      mode: 'range',
      onClose: function(selectedDates) {
        if (selectedDates.length === 2) {
          formElement.submit();
        }
      },
      locale: {
        "firstDayOfWeek": 1 // start week on Monday
      },
      locale: Spanish
    }

    return flatpickr(search, search.config)
  }
}

export const Spanish = {
  weekdays: {
    shorthand: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"],
    longhand: [
      "Domingo",
      "Lunes",
      "Martes",
      "Miércoles",
      "Jueves",
      "Viernes",
      "Sábado",
    ],
  },

  months: {
    shorthand: [
      "Ene",
      "Feb",
      "Mar",
      "Abr",
      "May",
      "Jun",
      "Jul",
      "Ago",
      "Sep",
      "Oct",
      "Nov",
      "Dic",
    ],
    longhand: [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre",
    ],
  },

  ordinal: () => {
    return "º";
  },

  firstDayOfWeek: 1,
  rangeSeparator: " a ",
  time_24hr: true,
};

