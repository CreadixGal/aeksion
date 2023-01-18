import { Controller } from "@hotwired/stimulus"
import flatpickr  from "flatpickr"

export default class extends Controller {
  connect() {
    console.log('Flatpickr controller connected')

    this.calendar()
    console.log(this.calendar())
  }

  calendar() {
    const today = new Date()
    let calendar = flatpickr(this.element, this.config)
    console.log(calendar.config)
    this.config = {
      enableTime: false,
      dateFormat: "d-m-Y",
      allowInput: true,
      maxDate: today,
      disable: [
        function(date) {
            return (date.getDay() === 0 || date.getDay() === 6);

        }
      ],
      locale: {
        "firstDayOfWeek": 1 // start week on Monday
      },
      locale: Spanish

    }
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

